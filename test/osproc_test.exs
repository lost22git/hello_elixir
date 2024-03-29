defmodule OsProcTest do
  use ExUnit.Case

  test "system cmd" do
    # cmd stdout behaviour: PIPE
    # run cmd and read all to string
    {out_string, exit_status} = System.cmd("elixir", ["-v"])
    IO.puts(out_string)
    assert exit_status == 0

    # cmd stdout behaviour: PIPE
    # run cmd and read lines into list
    {out_lines, exit_status} = System.cmd("elixir", ["-v"], into: [], lines: 1024)
    assert exit_status == 0
    assert (out_lines |> Enum.join("\n")) <> "\n" == out_string

    # cmd stdout behaviour: INHERIT
    # run cmd and write into stdio
    {_out_stream, exit_status} = System.cmd("elixir", ["-v"], into: IO.stream())
    assert exit_status == 0

    # cmd stdout behaviou: REDIRECT TO FILE
    # run cmd and write into file
    temp_file_path =
      System.tmp_dir!()
      |> Path.join("elixir_test_run_cmd_and_write_into_file")

    temp_fd =
      temp_file_path
      |> File.open!([:write])

    {_out_stream, exit_status} =
      System.cmd("elixir", ["-v"], into: IO.stream(temp_fd, :line))

    assert exit_status == 0
    assert File.read!(temp_file_path) == out_string

    # redirect cmd stderr to cmd stdout
    {out_string, exit_status} = System.cmd("elixir", ["-vv"], stderr_to_stdout: true)
    assert exit_status == 1
    assert out_string == "No file named -vv\n"

    # raise error when program is not found
    try do
      {_out_string, _exit_status} = System.cmd("elixirrrrr", ["-v"], stderr_to_stdout: true)
    rescue
      e -> assert Exception.message(e) == "Erlang error: :enoent"
    end

    # TODO: how to get cmd stderr output directly instead of `stderr_to_stdout: true`
  end

  test "system shell" do
    # 用法和 System.cmd 类似
    {out_string, exit_status} = System.shell("elixir -v")
    assert exit_status == 0

    {out_lines, exit_status} = System.shell("elixir -v", into: [], lines: 1024)
    assert exit_status == 0
    assert (out_lines |> Enum.join("\n")) <> "\n" == out_string

    {out_string, exit_status} = System.shell("elixirrrr -v 2>&1")
    assert exit_status == 1

    case :os.type() do
      {:win32, _} ->
        {
          assert(
            out_string ==
              "'elixirrrr' is not recognized as an internal or external command,\r\noperable program or batch file.\r\n"
          )
        }
    end
  end
end
