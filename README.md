# RefactoringExample

Example app designed to show the process of extracting private functions
and internal modules.

## Running

1. Install the dependencies: `mix deps.get`
2. Run the app from iex

    ```elixir
    $ iex -S mix
    Erlang/OTP 22 [erts-10.4.4] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

    Compiling 2 files (.ex)
    Interactive Elixir (1.9.1) - press Ctrl+C to exit (type h() ENTER for help)
    iex(1)> RefactoringExample.print_cars()
    #... output
    ```

## Generating documentation

You can view the public API for this application with the following command

```
$ mix docs
Docs successfully generated.
View them at "doc/index.html".
$ open doc/index.html
```
