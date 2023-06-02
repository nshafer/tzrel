# TZ module release problem reproduction

Example of issues arising when building an Elixir Release that uses the tz library while also customizing the data_dir
config option at runtime. The tz library will work, since it does do an `Application.get_env/3` at runtime where needed,
but there's also an `Application.compile_env/3` call in `compiler_runner.ex` that causes `mix release` to throw the
following error and crash:

    ERROR! the application :tz has a different value set for key :data_dir during runtime compared to compile time.

## Setup

1. Clone this repo
2. `mix deps.get` to fetch tz, mint, castore

## Confirm normal working

Run `iex -S mix`. There are two functions to validate normal working at runtime, `TzRel.debug()` and
`TzRel.tz_download()`.

    iex(1)> TzRel.debug()      
    This shows that the tz module is properly getting the updated data_dir atruntime, as it should output 'local/tz' which is set in config/runtime.exs.

    tz data_dir: local/tz/
    :ok
    iex(2)> TzRel.tz_download()
    This will get the tz data_dir via Tz.IanaDataDir.dir() which is the same function used by the `mix tz.download` task, as well as the Tz.UpdatePeriodically genserver. So when you run this, it will force a download of an old iana tz database, 2021a. If everything is working properly, then it will be output into `local/tz/tzdata2021a`.

    12:47:09.843 [info] Tz is downloading the IANA time zone data version 2021a at https://data.iana.org/time-zones/releases/tzdata2021a.tar.gz
    
    12:47:10.501 [info] Tz download done
    IANA time zone data for version 2021a has been extracted into local/tz/tzdata2021a

    12:47:10.535 [info] IANA time zone data extracted into local/tz/tzdata2021a
    :ok

## Reproduce release problem

First, create a release by running `mix release`. It will output to default location `_build/dev/rel/tzrel`.

Then try to run it with `_build/dev/rel/tzrel/bin/tzrel start_iex` and you'll see the elixir release system detecting
an error and dying.

    $ _build/dev/rel/tzrel/bin/tzrel start_iex
    Erlang/OTP 25 [erts-13.2] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit:ns]

    runtime.exs env:dev
    Setting tz data_dir to local/tz/ at runtime
    ERROR! the application :tz has a different value set for key :data_dir during runtime compared to compile time. Since this application environment entry was marked as compile time, this difference can lead to different behaviour than expected:

      * Compile time value was not set
      * Runtime value was set to: "local/tz/"

    To fix this error, you might:

      * Make the runtime value match the compile time one

      * Recompile your project. If the misconfigured application is a dependency, you may need to run "mix deps.compile tz --force"

      * Alternatively, you can disable this check. If you are using releases, you can set :validate_compile_env to false in your release configuration. If you are using Mix to start your system, you can pass the --no-validate-compile-env flag


    {"init terminating in do_boot",{<<"aborting boot">>,[{'Elixir.Config.Provider',boot,2,[]}]}}
    init terminating in do_boot ({,[{Elixir.Config.Provider,boot,2,[]}]})

    Crash dump is being written to: erl_crash.dump...done
