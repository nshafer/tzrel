import Config

IO.puts("runtime.exs env:#{Config.config_env()}")

IO.puts("Setting tz data_dir to local/tz/ at runtime")
config :tz, :data_dir, "local/tz/"
