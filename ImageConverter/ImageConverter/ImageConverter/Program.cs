using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using SixLabors.ImageSharp.Processing;
using System;
using System.CommandLine;
using System.CommandLine.Invocation;
using TgaLib;
using static System.Net.Mime.MediaTypeNames;

class Program
{
    static void Main(string[] args)
    {
        var rootCommand = new RootCommand
        {
            new Option<string>("--in", "Input image path"),
            new Option<string>("--out", "Output image path")
        };

        rootCommand.Handler = CommandHandler.Create<string, string>(ConvertAndResizeImage);

        rootCommand.InvokeAsync(args).Wait();
    }

    static void ConvertAndResizeImage(string @in, string @out)
    {
        using var image = Image.Load<Rgba32>(@in);

        // Resize the image to the nearest power of 2
        int width = (int)Math.Pow(2, Math.Ceiling(Math.Log(image.Width) / Math.Log(2)));
        int height = (int)Math.Pow(2, Math.Ceiling(Math.Log(image.Height) / Math.Log(2)));

        image.Mutate(x => x
            .Resize(width, height)
            .Quantize(new SixLabors.ImageSharp.Processing.Processors.Quantization.WernerQuantizer(new SixLabors.ImageSharp.Processing.Processors.Quantization.WernerPaletteCount(16))));

        // Save as TGA
        var tgaWriter = new TgaWriter();
        tgaWriter.Write(@out, image);

        Console.WriteLine($"Image converted and saved to {@out}");
    }
}