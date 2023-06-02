defmodule TzRel do
  def debug() do
    IO.puts("This shows that the tz module is properly getting the updated data_dir at"
      <> "runtime, as it should output 'local/tz' which is set in config/runtime.exs.\n")
    tz_data_dir = Application.get_env(:tz, :data_dir)
    IO.puts("tz data_dir: #{tz_data_dir}")
  end

  def tz_download() do
    IO.puts("This will get the tz data_dir via Tz.IanaDataDir.dir() which is the same "
      <> "function used by the `mix tz.download` task, as well as the Tz.UpdatePeriodically "
      <> "genserver. So when you run this, it will force a download of an old iana tz "
      <> "database, 2021a. If everything is working properly, then it will be output "
      <> "into `local/tz/tzdata2021a`.")

    version = "2021a"
    dir = Tz.IanaDataDir.dir()

    case Tz.Updater.update_tz_database(version, dir) do
      :error ->
        IO.puts("failed to download IANA data for version #{version}")

      {:ok, dir} ->
        IO.puts("IANA time zone data for version #{version} has been extracted into #{dir}")
    end
  end
end
