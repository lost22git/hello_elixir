defmodule OsProcTest do
  use ExUnit.Case

  test "system cmd" do
    # PIPE cmd stdout
    # run cmd and read all to string
    {out_string, exit_status} = System.cmd("elixir", ["-v"])
    IO.puts(out_string)
    assert exit_status == 0

    # PIPE cmd stdout
    # run cmd and read lines into list
    {out_lines, exit_status} = System.cmd("elixir", ["-v"], into: [], lines: 1024)
    assert exit_status == 0
    assert (out_lines |> Enum.join("\n")) <> "\n" == out_string

    # INHERIT cmd stdout
    # run cmd and write into stdio
    {out_stream, exit_status} = System.cmd("elixir", ["-v"], into: IO.stream())
    assert exit_status == 0

    # REDIRECT cmd stdout TO FILE
    # run cmd and write into file
    temp_file_path =
      System.get_env("TEMP")
      |> Path.join("elixir_test_run_cmd_and_write_into_file")

    temp_fd =
      temp_file_path
      |> File.open!([:write])

    {out_stream, exit_status} =
      System.cmd("elixir", ["-v"], into: IO.stream(temp_fd, :line))

    assert exit_status == 0
    assert File.read!(temp_file_path) == out_string

    # redirect stderr to stdout
    {out_string, exit_status} = System.cmd("elixir", ["-vv"], stderr_to_stdout: true)
    assert exit_status == 1
    assert out_string == "No file named -vv\n"

    # raise error when program is not found
    try do
      {out_string, exit_status} = System.cmd("elixirrrrr", ["-v"], stderr_to_stdout: true)
    rescue
      e -> assert Exception.message(e) == "Erlang error: :enoent"
    end

    # TODO: how to get cmd stderr output directly instead of `stderr_to_stdout: true`
  end
end
