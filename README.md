# VegaLite

[![Actions Status](https://github.com/elixir-nx/vega_lite/workflows/Test/badge.svg)](https://github.com/elixir-nx/vega_lite/actions)
[![Docs](https://img.shields.io/badge/docs-gray.svg)](https://hexdocs.pm/vega_lite)

Elixir bindings to [Vega-Lite](https://vega.github.io/vega-lite).

You can use it inside Livebook to plot graphics or in regular Elixir
projects to save graphics to PNG, SVG, PDF, or render them using a
webviewer.

[See the documentation](https://hexdocs.pm/vega_lite).

## Installation

### Inside Livebook

You most likely want to use VegaLite in [Livebook](https://github.com/elixir-nx/livebook),
in which case you can call `Mix.install/2`:

```elixir
Mix.install([
  {:vega_lite, "~> 0.1.4"},
  {:kino, "~> 0.5.0"}
])
```

You will also want [Kino](https://github.com/elixir-nx/kino) to ensure
Livebook renders the graphics nicely. There is an introductory guide
to VegaLite in the "Explore" section of your Livebook application.

### In Mix projects

You can add the `:vega_lite` dependency to your `mix.exs`:

```elixir
def deps do
  [
    {:vega_lite, "~> 0.1.4"}
  ]
end
```

## License

Copyright (C) 2021 Dashbit

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
