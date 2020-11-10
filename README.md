# Installing
1. Close Emacs.
2. Delete `~/.emacs` or `~/.emacs.d`, if you already have it.
3. Run `git clone https://github.com/pratik-abhyankar/dot-emacs-dot-d.git ~/.emacs.d`
4. Install the required utilities and font as mentioned in the Resources and Font section below.
5. Open Emacs, it will download all the packages. (Ignore the warnings on the first launch)
6. Start using it! :tada:

# Fonts
I prefer to use [Hack](https://github.com/source-foundry/Hack) as my default font for development. This configuration will use that font if it is already installed on the system, else default to the current system font.

# Resources
You would need to install some utilities manually on your system using a custom or your system's default package manager like `brew`, `apt`, `yum` or `choco` etc. Following is a list of all the utilities used by this configuration:  
  1. [Pandoc](https://pandoc.org/)  
    * Used by `markdown-mode` for previewing and exporting `.md` documents.  
    * Install on MacOS with [Brew](https://brew.sh/) as `brew install pandoc`.  
    * Install on Linux as `apt install pandoc` or `yum install pandoc`  
    * Install on Windows with [Chocolatey](https://chocolatey.org/) as `choco install pandoc`

# Credits
This project is adapted from [Suvrat Apte's](https://github.com/suvratapte/dot-emacs-dot-d) Emacs configuration.
