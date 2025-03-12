# Typst Slide Template

This is a Typst slide template based on [touying-typ/touying](https://github.com/touying-typ/touying), a powerful presentation framework for Typst.

## Features

- Clean and modern design
- Easy to customize
- Based on the touying presentation framework
- Includes basic slide layouts

## Using with VSCode
- ![ti](https://github.com/user-attachments/assets/7ab2a6c3-a561-4a04-8a70-f3f83a471422) Install the **Tynymist** extension ~~instead of Typst LSP, Typst Preview, etc.~~

- Preview in main.typ \
  Click the icon like this ![image](https://github.com/user-attachments/assets/9ca16971-f82a-4452-af57-5e640b69d1c9) in the top right corner.

- Generate PDF \
  Click the icon like this ![image](https://github.com/user-attachments/assets/740fee65-06ba-4d58-a352-23963d6891fb) in the top right corner.

## Pympress
Using [Pympress](https://github.com/Cimbali/pympress), you can prepare a "PDF with comment notes" and display it on multiple displays.

1. first, in `src/configs.typp`, add
  ```typst
  show-notes-on-second-screen: right,.
  ```
  and the pdf output
  ![image](https://github.com/user-attachments/assets/1669576c-92b4-49c1-9ab5-c2b4775bd53f)
  A pdf is output with the slides and notes combined, as shown in the image above.



2. Install [Pympress](https://github.com/Cimbali/pympress)
  - Ubuntu
  ```bash
  apt-get install pympress libgtk-3-0 libpoppler-glib8 libcairo2 python3-gi python3-gi-cairo gobject-introspection libgirepository-1.0-1 gir1.2-gtk-3.0 gir1.2-poppler-0.18
  ```

  - macOS

  ```sh
  brew install pympress
  ```

  - Windows Package Manager (winget)

  ```batch
  winget install pympress
  ```
3. Start Pympress, open pdf

   ![image](https://github.com/user-attachments/assets/2d48d1c4-17e8-40ee-9eaa-d81f412af89c)

   You can view it in presenter mode like this



## Credits

This template is built using [touying-typ/touying](https://github.com/touying-typ/touying). Special thanks to the original project contributors.

## License

MIT License - See [LICENSE](LICENSE) file for details
