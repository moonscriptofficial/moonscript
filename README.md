<p align="center">
  <a href="https://github.com/moonscriptofficial/moonscript">
    <img height="128" src="https://github.com/moonscriptofficial/moonscript/blob/main/assets/moon.png">
  </a>
  <h1 align="center">MoonScript</h1>
</p>

<p align="center">
  <a href="https://www.npmjs.com/package/your-language">
    <img src="https://img.shields.io/npm/dm/your-language.svg" alt="NPM downloads"/>
  </a>
  <a href="https://github.com/your-repository/issues">
    <img src="https://img.shields.io/github/issues/your-repository" alt="Open Issues"/>
  </a>
  <a href="https://github.com/your-repository/pulls">
    <img src="https://img.shields.io/github/prs/your-repository" alt="Pull Requests"/>
  </a>
</p>


## Overview

Welcome to **MoonScript**, the next-generation, full-stack web programming language designed for **simplicity**, **speed**, and **efficiency**! 🚀

With **MoonScript**, you can develop dynamic and scalable web applications with **ease** and **speed**. The syntax is intuitive, and compilation times are drastically reduced, making development faster than ever before. It is tailored to help developers build modern, interactive web apps, and is packed with powerful features that ensure your projects stay lightweight and performant.

---

## Features

- 🔥 **Low Compilation Time**: MoonScript compiles faster than traditional frameworks, thanks to its lightweight and optimized architecture.
- 🚀 **Faster Execution**: Code written in **MoonScript** runs **faster** compared to others, thanks to its low-level optimizations.
- 🌍 **Cross-Platform Support**: Seamlessly write applications that can run on all platforms with minimal code changes.
- 🧩 **Component-Based Design**: Write reusable, self-contained components with the same structure you use for HTML and CSS.
- 💻 **Web Focused**: Perfect for building both the **frontend** and **backend** of modern web applications.
- 🎨 **CSS-Inspired Styling**: Writing styles has never been easier, as our syntax for styles is directly influenced by CSS. You’ll feel right at home if you’re familiar with web design.

---

## Example Syntax

Here's a simple component written in **MoonScript** that demonstrates how easy it is to define components, properties, and styles:

```ruby
component HelloWorld {
  property color = "#333"
  property done = false
  property label = ""

  style label {
    font-weight: bold;
    color: #{color};
    flex: 1;

    if (done) {
      text-decoration: line-through;
    }
  }

  fun render {
    <div>
      <span::label>
        label
      </span>
    </div>
  }
}
```

### Explanation:
- **Component Definition**: The `component TodoItem` block defines a reusable component that encapsulates all its properties, styling, and behavior.
- **Properties**: Properties like `color`, `done`, and `label` are defined within the component and can be accessed throughout the component's lifecycle.
- **Styling**: The `style` block defines how elements inside the component will look. It’s similar to CSS, but with more power and flexibility.
- **Render Function**: The `fun render` function is where the UI elements are rendered using the component's properties and styling.

---

## Why Choose **MoonScript**?

### ⚡ **Speed** 
When it comes to web development, speed is crucial. Unlike other frameworks, **MoonScript** is designed to minimize compilation times without sacrificing performance. The end result? **Lightning-fast compilation and execution**.

### 🌐 **Web-first Design**
Built for the web, **MoonScript** makes it easy to create web applications that are scalable and maintainable. Whether you're working on small websites or large-scale applications, this language supports both.

### 🔧 **Minimal Boilerplate**
We’ve made sure to keep things simple. With **MoonScript**, you don't have to write hundreds of lines of setup code. Focus more on building features and less on configuration.

### 🌟 **Ready for Production**
With a lightweight, optimized architecture, **MoonScript** ensures your web apps run smoothly from day one, giving you **performance** you can rely on.

---

## Installation

To get started with **MoonScript**, simply follow the installation steps below.

### 1. Create Your First Project

```bash
moon init AwesomeProject
cd AwesomeProject
moon start
```

### 2. Start Coding!

Your development server should now be running! Open your browser to `http://localhost:3000`, and you’re ready to start building!

---

## Contributing

We’re always looking for contributors to help us improve **MoonScript**. If you have ideas, fixes, or features you’d like to contribute, feel free to open an issue or submit a pull request!

### How to Contribute:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-name`).
3. Make your changes.
4. Commit your changes (`git commit -am 'Add new feature'`).
5. Push to the branch (`git push origin feature-name`).
6. Open a pull request.

---

## License

Distributed under the **MIT License**. See the [LICENSE](LICENSE) file for more information.

---

## Let's Build Together!

With **MoonScript**, building web applications is a breeze! Whether you're a beginner or an experienced developer, our toolset will help you ship products faster than ever before.

Feel free to check out the source code, contribute, or just get started on your next project!

Happy coding! 🌟
