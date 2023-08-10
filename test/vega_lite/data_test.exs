defmodule VegaLite.DataTest do
  use ExUnit.Case

  alias VegaLite.Data
  alias VegaLite, as: Vl

  @data [
    %{"height" => 170, "weight" => 80, "width" => 10, "unused" => "a"},
    %{"height" => 190, "weight" => 85, "width" => 20, "unused" => "b"}
  ]

  describe "shorthand api" do
    test "single field" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height"])
        |> Vl.mark(:bar)
        |> Vl.encode_field(:x, "height", type: :quantitative)

      assert vl == Data.chart(@data, :bar, x: "height")
    end

    test "multiple fields" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.mark(:bar)
        |> Vl.encode_field(:x, "height", type: :quantitative)
        |> Vl.encode_field(:y, "weight", type: :quantitative)

      assert vl == Data.chart(@data, :bar, x: "height", y: "weight")
    end

    test "mark with options" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height"])
        |> Vl.mark(:point, line: true)
        |> Vl.encode_field(:x, "height", type: :quantitative)

      assert vl == Data.chart(@data, [type: :point, line: true], x: "height")
    end

    test "mark from pipe" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height"])
        |> Vl.mark(:point, line: true)
        |> Vl.encode_field(:x, "height", type: :quantitative)

      assert vl == Vl.new() |> Vl.mark(:point, line: true) |> Data.chart(@data, x: "height")
    end

    test "pipe to mark" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height"])
        |> Vl.encode_field(:x, "height", type: :quantitative)
        |> Vl.mark(:point, line: true)

      assert vl == Vl.new() |> Data.chart(@data, x: "height") |> Vl.mark(:point, line: true)
    end

    test "single field with options" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height"])
        |> Vl.mark(:bar)
        |> Vl.encode_field(:x, "height", type: :nominal)

      assert vl == Data.chart(@data, :bar, x: [field: "height", type: :nominal])
    end

    test "multiple fields with options" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.mark(:bar)
        |> Vl.encode_field(:x, "height", type: :nominal)
        |> Vl.encode_field(:y, "weight", type: :nominal)

      assert vl ==
               Data.chart(@data, :bar,
                 x: [field: "height", type: :nominal],
                 y: [field: "weight", type: :nominal]
               )
    end

    test "nested field options" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height"])
        |> Vl.mark(:bar)
        |> Vl.encode_field(:x, "height", type: :quantitative)
        |> Vl.encode_field(:color, "height", type: :quantitative, scale: [scheme: "category10"])

      assert vl ==
               Data.chart(@data, :bar,
                 x: "height",
                 color: [field: "height", type: :quantitative, scale: [scheme: "category10"]]
               )
    end

    test "piped from VegaLite" do
      vl =
        Vl.new(title: "With title")
        |> Vl.data_from_values(@data, only: ["height"])
        |> Vl.mark(:point)
        |> Vl.encode_field(:x, "height", type: :quantitative)

      assert vl == Vl.new(title: "With title") |> Data.chart(@data, :point, x: "height")
    end

    test "piped into VegaLite" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height"])
        |> Vl.mark(:point)
        |> Vl.encode_field(:x, "height", type: :quantitative)
        |> Vl.encode_field(:color, "height", type: :quantitative, scale: [scheme: "category10"])

      assert vl ==
               Data.chart(@data, :point, x: "height")
               |> Vl.encode_field(:color, "height",
                 type: :quantitative,
                 scale: [scheme: "category10"]
               )
    end

    test "piped into VegaLite with extra fields" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.mark(:point)
        |> Vl.encode_field(:x, "height", type: :quantitative)
        |> Vl.encode_field(:color, "weight", type: :quantitative, scale: [scheme: "category10"])

      assert vl ==
               Data.chart(@data, :point, x: "height", extra_fields: ["weight"])
               |> Vl.encode_field(:color, "weight",
                 type: :quantitative,
                 scale: [scheme: "category10"]
               )
    end

    test "piped from and into VegaLite" do
      vl =
        Vl.new(title: "With title")
        |> Vl.data_from_values(@data, only: ["height"])
        |> Vl.mark(:point)
        |> Vl.encode_field(:x, "height", type: :quantitative)
        |> Vl.encode_field(:color, "height", type: :quantitative, scale: [scheme: "category10"])

      assert vl ==
               Vl.new(title: "With title")
               |> Data.chart(@data, :point, x: "height")
               |> Vl.encode_field(:color, "height",
                 type: :quantitative,
                 scale: [scheme: "category10"]
               )
    end

    test "piped from and into VegaLite with extra fields" do
      vl =
        Vl.new(title: "With title")
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.mark(:point)
        |> Vl.encode_field(:x, "height", type: :quantitative)
        |> Vl.encode_field(:color, "weight", type: :quantitative, scale: [scheme: "category10"])

      assert vl ==
               Vl.new(title: "With title")
               |> Data.chart(@data, :point, x: "height", extra_fields: ["weight"])
               |> Vl.encode_field(:color, "weight",
                 type: :quantitative,
                 scale: [scheme: "category10"]
               )
    end

    test "combined with layers" do
      vl =
        Vl.new(title: "Heatmap")
        |> Vl.layers([
          Vl.new()
          |> Vl.data_from_values(@data, only: ["height", "weight"])
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :nominal)
          |> Vl.encode_field(:y, "weight", type: :nominal)
          |> Vl.encode_field(:color, "height", type: :quantitative),
          Vl.new()
          |> Vl.data_from_values(@data, only: ["height", "weight"])
          |> Vl.mark(:text)
          |> Vl.encode_field(:x, "height", type: :nominal)
          |> Vl.encode_field(:y, "weight", type: :nominal)
          |> Vl.encode_field(:text, "height", type: :quantitative)
        ])

      sh =
        Vl.new(title: "Heatmap")
        |> Vl.layers([
          Data.chart(@data, :rect,
            x: [field: "height", type: :nominal],
            y: [field: "weight", type: :nominal],
            color: "height"
          ),
          Data.chart(@data, :text,
            x: [field: "height", type: :nominal],
            y: [field: "weight", type: :nominal],
            text: "height"
          )
        ])

      assert vl == sh
    end
  end

  describe "heatmap" do
    test "simple" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :nominal)
          |> Vl.encode_field(:y, "weight", type: :nominal)
        ])

      assert vl == Data.heatmap(@data, x: "height", y: "weight")
    end

    test "with color" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :nominal)
          |> Vl.encode_field(:y, "weight", type: :nominal)
          |> Vl.encode_field(:color, "height", type: :quantitative)
        ])

      assert vl == Data.heatmap(@data, x: "height", y: "weight", color: "height")
    end

    test "with text and color" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :nominal)
          |> Vl.encode_field(:y, "weight", type: :nominal)
          |> Vl.encode_field(:color, "height", type: :quantitative),
          Vl.new()
          |> Vl.mark(:text)
          |> Vl.encode_field(:x, "height", type: :nominal)
          |> Vl.encode_field(:y, "weight", type: :nominal)
          |> Vl.encode_field(:text, "height", type: :quantitative)
        ])

      assert vl == Data.heatmap(@data, x: "height", y: "weight", color: "height", text: "height")
    end

    test "with title and extra fields" do
      vl =
        Vl.new(title: "Heatmap")
        |> Vl.data_from_values(@data, only: ["height", "weight", "width"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :nominal)
          |> Vl.encode_field(:y, "weight", type: :nominal)
          |> Vl.encode_field(:color, "height", type: :quantitative),
          Vl.new()
          |> Vl.mark(:text)
          |> Vl.encode_field(:x, "height", type: :nominal)
          |> Vl.encode_field(:y, "weight", type: :nominal)
          |> Vl.encode_field(:text, "height", type: :quantitative)
        ])

      assert vl ==
               Vl.new(title: "Heatmap")
               |> Data.heatmap(@data,
                 x: "height",
                 y: "weight",
                 color: "height",
                 text: "height",
                 extra_fields: ["width"]
               )
    end

    test "with specified types" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :quantitative)
          |> Vl.encode_field(:y, "weight", type: :quantitative)
          |> Vl.encode_field(:color, "height", type: :nominal),
          Vl.new()
          |> Vl.mark(:text)
          |> Vl.encode_field(:x, "height", type: :quantitative)
          |> Vl.encode_field(:y, "weight", type: :quantitative)
          |> Vl.encode_field(:text, "height", type: :quantitative)
        ])

      assert vl ==
               Data.heatmap(@data,
                 x: [field: "height", type: :quantitative],
                 y: [field: "weight", type: :quantitative],
                 color: [field: "height", type: :nominal],
                 text: "height"
               )
    end

    test "with a text field different from the axes" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight", "width"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :nominal)
          |> Vl.encode_field(:y, "weight", type: :nominal)
          |> Vl.encode_field(:color, "height", type: :quantitative),
          Vl.new()
          |> Vl.mark(:text)
          |> Vl.encode_field(:x, "height", type: :nominal)
          |> Vl.encode_field(:y, "weight", type: :nominal)
          |> Vl.encode_field(:text, "width", type: :quantitative)
        ])

      assert vl == Data.heatmap(@data, x: "height", y: "weight", color: "height", text: "width")
    end

    test "raises an error when the x field is not given" do
      assert_raise ArgumentError, "the x field is required to plot a heatmap", fn ->
        Data.heatmap(@data, y: "y")
      end
    end

    test "raises an error when the y field is not given" do
      assert_raise ArgumentError, "the y field is required to plot a heatmap", fn ->
        Data.heatmap(@data, x: "x", text: "text")
      end
    end
  end

  describe "density heatmap" do
    test "simple density heatmap" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :quantitative, bin: true)
          |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true)
          |> Vl.encode_field(:color, "height", type: :quantitative, aggregate: :count)
        ])

      assert vl == Data.density_heatmap(@data, x: "height", y: "weight", color: "height")
    end

    test "with title" do
      vl =
        Vl.new(title: "Density heatmap")
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :quantitative, bin: true)
          |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true)
          |> Vl.encode_field(:color, "height", type: :quantitative, aggregate: :count)
        ])

      assert vl ==
               Vl.new(title: "Density heatmap")
               |> Data.density_heatmap(@data, x: "height", y: "weight", color: "height")
    end

    test "with specified bins" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :quantitative, bin: [maxbins: 10])
          |> Vl.encode_field(:y, "weight", type: :quantitative, bin: [maxbins: 10])
          |> Vl.encode_field(:color, "height", type: :quantitative, aggregate: :count)
        ])

      assert vl ==
               Data.density_heatmap(@data,
                 x: [field: "height", bin: [maxbins: 10]],
                 y: [field: "weight", bin: [maxbins: 10]],
                 color: "height"
               )
    end

    test "with specified aggregate for color" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :quantitative, bin: true)
          |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true)
          |> Vl.encode_field(:color, "height", type: :quantitative, aggregate: :mean)
        ])

      assert vl ==
               Data.density_heatmap(@data,
                 x: "height",
                 y: "weight",
                 color: [field: "height", aggregate: :mean]
               )
    end

    test "with text" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :quantitative, bin: true)
          |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true)
          |> Vl.encode_field(:color, "height", type: :quantitative, aggregate: :count),
          Vl.new()
          |> Vl.mark(:text)
          |> Vl.encode_field(:x, "height", type: :quantitative, bin: true)
          |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true)
          |> Vl.encode_field(:text, "height", type: :quantitative, aggregate: :count)
        ])

      assert vl ==
               Data.density_heatmap(@data,
                 x: "height",
                 y: "weight",
                 color: "height",
                 text: "height"
               )
    end

    test "with specified aggregate for text" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :quantitative, bin: true)
          |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true)
          |> Vl.encode_field(:color, "height", type: :quantitative, aggregate: :count),
          Vl.new()
          |> Vl.mark(:text)
          |> Vl.encode_field(:x, "height", type: :quantitative, bin: true)
          |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true)
          |> Vl.encode_field(:text, "height", type: :quantitative, aggregate: :mean)
        ])

      assert vl ==
               Data.density_heatmap(@data,
                 x: "height",
                 y: "weight",
                 color: "height",
                 text: [field: "height", aggregate: :mean]
               )
    end

    test "with text different from the axes" do
      vl =
        Vl.new()
        |> Vl.data_from_values(@data, only: ["height", "weight", "width"])
        |> Vl.layers([
          Vl.new()
          |> Vl.mark(:rect)
          |> Vl.encode_field(:x, "height", type: :quantitative, bin: true)
          |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true)
          |> Vl.encode_field(:color, "height", type: :quantitative, aggregate: :count),
          Vl.new()
          |> Vl.mark(:text)
          |> Vl.encode_field(:x, "height", type: :quantitative, bin: true)
          |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true)
          |> Vl.encode_field(:text, "width", type: :quantitative, aggregate: :count)
        ])

      assert vl ==
               Data.density_heatmap(@data,
                 x: "height",
                 y: "weight",
                 color: "height",
                 text: "width"
               )
    end

    test "raises an error when the x field is not given" do
      assert_raise ArgumentError, "the x field is required to plot a density heatmap", fn ->
        Data.density_heatmap(@data, y: "y")
      end
    end

    test "raises an error when the y field is not given" do
      assert_raise ArgumentError, "the y field is required to plot a density heatmap", fn ->
        Data.density_heatmap(@data, x: "x", text: "text")
      end
    end

    test "raises an error when the color field is not given" do
      assert_raise ArgumentError, "the color field is required to plot a density heatmap", fn ->
        Data.density_heatmap(@data, x: "x", y: "y")
      end
    end
  end

  describe "jointplot" do
    test "simple jointplot" do
      vl =
        Vl.new(spacing: 15, bounds: :flush)
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.concat(
          [
            Vl.new(height: 60)
            |> Vl.mark(:bar)
            |> Vl.encode_field(:x, "height", type: :quantitative, bin: true, axis: nil)
            |> Vl.encode_field(:y, "height", type: :quantitative, aggregate: :count, title: ""),
            Vl.new(spacing: 15, bounds: :flush)
            |> Vl.concat([
              Vl.new()
              |> Vl.mark(:circle)
              |> Vl.encode_field(:x, "height", type: :quantitative)
              |> Vl.encode_field(:y, "weight", type: :quantitative),
              Vl.new(width: 60)
              |> Vl.mark(:bar)
              |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true, axis: nil)
              |> Vl.encode_field(:x, "weight", type: :quantitative, aggregate: :count, title: "")
            ])
          ],
          :vertical
        )

      assert vl == Data.joint_plot(@data, :circle, x: "height", y: "weight")
    end

    test "with title" do
      vl =
        Vl.new(title: "Jointplot", spacing: 15, bounds: :flush)
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.concat(
          [
            Vl.new(height: 60)
            |> Vl.mark(:bar)
            |> Vl.encode_field(:x, "height", type: :quantitative, bin: true, axis: nil)
            |> Vl.encode_field(:y, "height", type: :quantitative, aggregate: :count, title: ""),
            Vl.new(spacing: 15, bounds: :flush)
            |> Vl.concat([
              Vl.new()
              |> Vl.mark(:circle)
              |> Vl.encode_field(:x, "height", type: :quantitative)
              |> Vl.encode_field(:y, "weight", type: :quantitative),
              Vl.new(width: 60)
              |> Vl.mark(:bar)
              |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true, axis: nil)
              |> Vl.encode_field(:x, "weight", type: :quantitative, aggregate: :count, title: "")
            ])
          ],
          :vertical
        )

      assert vl ==
               Vl.new(title: "Jointplot")
               |> Data.joint_plot(@data, :circle, x: "height", y: "weight")
    end

    test "with custom width" do
      vl =
        Vl.new(title: "Jointplot", width: 500, spacing: 15, bounds: :flush)
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.concat(
          [
            Vl.new(height: 60, width: 500)
            |> Vl.mark(:bar)
            |> Vl.encode_field(:x, "height", type: :quantitative, bin: true, axis: nil)
            |> Vl.encode_field(:y, "height", type: :quantitative, aggregate: :count, title: ""),
            Vl.new(spacing: 15, bounds: :flush)
            |> Vl.concat([
              Vl.new(width: 500)
              |> Vl.mark(:circle)
              |> Vl.encode_field(:x, "height", type: :quantitative)
              |> Vl.encode_field(:y, "weight", type: :quantitative),
              Vl.new(width: 60)
              |> Vl.mark(:bar)
              |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true, axis: nil)
              |> Vl.encode_field(:x, "weight", type: :quantitative, aggregate: :count, title: "")
            ])
          ],
          :vertical
        )

      assert vl ==
               Vl.new(title: "Jointplot", width: 500)
               |> Data.joint_plot(@data, :circle, x: "height", y: "weight")
    end

    test "with custom height" do
      vl =
        Vl.new(title: "Jointplot", height: 350, spacing: 15, bounds: :flush)
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.concat(
          [
            Vl.new(height: 60)
            |> Vl.mark(:bar)
            |> Vl.encode_field(:x, "height", type: :quantitative, bin: true, axis: nil)
            |> Vl.encode_field(:y, "height", type: :quantitative, aggregate: :count, title: ""),
            Vl.new(spacing: 15, bounds: :flush)
            |> Vl.concat([
              Vl.new(height: 350)
              |> Vl.mark(:circle)
              |> Vl.encode_field(:x, "height", type: :quantitative)
              |> Vl.encode_field(:y, "weight", type: :quantitative),
              Vl.new(width: 60, height: 350)
              |> Vl.mark(:bar)
              |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true, axis: nil)
              |> Vl.encode_field(:x, "weight", type: :quantitative, aggregate: :count, title: "")
            ])
          ],
          :vertical
        )

      assert vl ==
               Vl.new(title: "Jointplot", height: 350)
               |> Data.joint_plot(@data, :circle, x: "height", y: "weight")
    end

    test "with custom width and height" do
      vl =
        Vl.new(title: "Jointplot", width: 500, height: 350, spacing: 15, bounds: :flush)
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.concat(
          [
            Vl.new(height: 60, width: 500)
            |> Vl.mark(:bar)
            |> Vl.encode_field(:x, "height", type: :quantitative, bin: true, axis: nil)
            |> Vl.encode_field(:y, "height", type: :quantitative, aggregate: :count, title: ""),
            Vl.new(spacing: 15, bounds: :flush)
            |> Vl.concat([
              Vl.new(width: 500, height: 350)
              |> Vl.mark(:circle)
              |> Vl.encode_field(:x, "height", type: :quantitative)
              |> Vl.encode_field(:y, "weight", type: :quantitative),
              Vl.new(width: 60, height: 350)
              |> Vl.mark(:bar)
              |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true, axis: nil)
              |> Vl.encode_field(:x, "weight", type: :quantitative, aggregate: :count, title: "")
            ])
          ],
          :vertical
        )

      assert vl ==
               Vl.new(title: "Jointplot", width: 500, height: 350)
               |> Data.joint_plot(@data, :circle, x: "height", y: "weight")
    end

    test "with color" do
      vl =
        Vl.new(spacing: 15, bounds: :flush)
        |> Vl.data_from_values(@data, only: ["height", "weight", "width"])
        |> Vl.concat(
          [
            Vl.new(height: 60)
            |> Vl.mark(:bar)
            |> Vl.encode_field(:x, "height", type: :quantitative, bin: true, axis: nil)
            |> Vl.encode_field(:y, "height", type: :quantitative, aggregate: :count, title: ""),
            Vl.new(spacing: 15, bounds: :flush)
            |> Vl.concat([
              Vl.new()
              |> Vl.mark(:circle)
              |> Vl.encode_field(:x, "height", type: :quantitative)
              |> Vl.encode_field(:y, "weight", type: :quantitative)
              |> Vl.encode_field(:color, "width", type: :quantitative),
              Vl.new(width: 60)
              |> Vl.mark(:bar)
              |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true, axis: nil)
              |> Vl.encode_field(:x, "weight", type: :quantitative, aggregate: :count, title: "")
            ])
          ],
          :vertical
        )

      assert vl == Data.joint_plot(@data, :circle, x: "height", y: "weight", color: "width")
    end

    test "with text" do
      vl =
        Vl.new(spacing: 15, bounds: :flush)
        |> Vl.data_from_values(@data, only: ["height", "weight", "width"])
        |> Vl.concat(
          [
            Vl.new(height: 60)
            |> Vl.mark(:bar)
            |> Vl.encode_field(:x, "height", type: :quantitative, bin: true, axis: nil)
            |> Vl.encode_field(:y, "height", type: :quantitative, aggregate: :count, title: ""),
            Vl.new(spacing: 15, bounds: :flush)
            |> Vl.concat([
              Vl.new()
              |> Vl.mark(:circle)
              |> Vl.encode_field(:x, "height", type: :quantitative)
              |> Vl.encode_field(:y, "weight", type: :quantitative)
              |> Vl.encode_field(:text, "width", type: :quantitative),
              Vl.new(width: 60)
              |> Vl.mark(:bar)
              |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true, axis: nil)
              |> Vl.encode_field(:x, "weight", type: :quantitative, aggregate: :count, title: "")
            ])
          ],
          :vertical
        )

      assert vl == Data.joint_plot(@data, :circle, x: "height", y: "weight", text: "width")
    end

    test "mark with options" do
      vl =
        Vl.new(spacing: 15, bounds: :flush)
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.concat(
          [
            Vl.new(height: 60)
            |> Vl.mark(:bar)
            |> Vl.encode_field(:x, "height", type: :quantitative, bin: true, axis: nil)
            |> Vl.encode_field(:y, "height", type: :quantitative, aggregate: :count, title: ""),
            Vl.new(spacing: 15, bounds: :flush)
            |> Vl.concat([
              Vl.new()
              |> Vl.mark(:point, filled: true)
              |> Vl.encode_field(:x, "height", type: :quantitative)
              |> Vl.encode_field(:y, "weight", type: :quantitative),
              Vl.new(width: 60)
              |> Vl.mark(:bar)
              |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true, axis: nil)
              |> Vl.encode_field(:x, "weight", type: :quantitative, aggregate: :count, title: "")
            ])
          ],
          :vertical
        )

      assert vl == Data.joint_plot(@data, [type: :point, filled: true], x: "height", y: "weight")
    end

    test "with a supported specialized as mark" do
      vl =
        Vl.new(spacing: 15, bounds: :flush)
        |> Vl.data_from_values(@data, only: ["height", "weight"])
        |> Vl.concat(
          [
            Vl.new(height: 60)
            |> Vl.mark(:bar)
            |> Vl.encode_field(:x, "height", type: :quantitative, bin: true, axis: nil)
            |> Vl.encode_field(:y, "height",
              type: :quantitative,
              aggregate: :count,
              title: ""
            ),
            Vl.new(spacing: 15, bounds: :flush)
            |> Vl.concat([
              Vl.new()
              |> Vl.layers([
                Vl.new()
                |> Vl.mark(:rect)
                |> Vl.encode_field(:x, "height", type: :quantitative, bin: true)
                |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true)
                |> Vl.encode_field(:color, "height", type: :quantitative, aggregate: :count),
                Vl.new()
                |> Vl.mark(:text)
                |> Vl.encode_field(:x, "height", type: :quantitative, bin: true)
                |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true)
                |> Vl.encode_field(:text, "height", type: :quantitative, aggregate: :count)
              ]),
              Vl.new(width: 60)
              |> Vl.mark(:bar)
              |> Vl.encode_field(:y, "weight", type: :quantitative, bin: true, axis: nil)
              |> Vl.encode_field(:x, "weight",
                type: :quantitative,
                aggregate: :count,
                title: ""
              )
            ])
          ],
          :vertical
        )

      assert vl ==
               Data.joint_plot(
                 @data,
                 :density_heatmap,
                 x: "height",
                 y: "weight",
                 color: "height",
                 text: "height"
               )
    end

    test "raises an error when the x field is not given" do
      assert_raise ArgumentError, "the x field is required to plot a jointplot", fn ->
        Data.joint_plot(@data, :point, y: "y")
      end
    end

    test "raises an error when the y field is not given" do
      assert_raise ArgumentError, "the y field is required to plot a jointplot", fn ->
        Data.joint_plot(@data, :bar, x: "x", text: "text")
      end
    end
  end
end
