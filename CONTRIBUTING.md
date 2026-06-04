# Contributing
All pull requests oriented to add features or fix bugs are welcome. Creating a new [Issue](https://github.com/EstebanAtHisComputer/KoboHighlights/issues) to discuss the feature or bug and let other contributors know you're tackling it is appreciated, although optional. Do check the pre-existing issues to make sure no one else is working on the exact same feature / bug as you.

## AI policy
Please do not submit pull requests containing AI-generated code. Code output by Large Language Models is faulty, unreliable and represents a security risk for the end users of the application. Pull requests suspected of containing AI generated code will take a longer review time and may be rejected.

Pull requests adding AI-powered features will be rejected, no exceptions.

## Development environment setup

To set up a development environment, please follow these steps:

1. First, make sure you have Flutter installed and properly configured on your system. You can find instructions to do so on [Flutter's official docs](https://docs.flutter.dev/get-started).

2. Clone the repo

   ```sh
   git clone https://github.com/EstebanAtHisComputer/KoboHighlights
   ```

3. Install and update dependencies
    ```sh
    flutter pub get
    ```
4. [Fork the project](https://docs.github.com/es/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo)
5. Create your feature branch (`git checkout -b feat/your_feature`)
6. Work now on your desired changes.
7. Commit your changes (`git commit -m 'feat: add your_feature'`)
8. Once you're done, push to the branch (`git push origin feat/your_feature`)
9. [Open a Pull Request](https://github.com/EstebanAtHisComputer/KoboHighlights/compare?expand=1)

## Compiling the project
While you can run the project with no issue with the `flutter run` and `flutter dev` commands, we offer an alternative option to build an `.appimage` file for Linux users instead of the default Linux executable file. We heavily recommend making sure the project compiles and functions correctly both with the default Flutter systems and as an '.appimage' before submitting the pull request.

Instructions to build the `.appimage` file can be found on the `Building from source` section of [README.md](https://github.com/EstebanAtHisComputer/KoboHighlights/blob/main/README.md).

## General guidelines
* If your features would affect  a single operating system (i.e you're fixing a bug that only affects Linux users), please make it clear when submitting your pull request.
* The project does not have a coding style guide at this time. For now, we default to the automatic formatting as done by the Flutter extension for Visual Studio Code, as per [the docs](https://docs.flutter.dev/tools/formatting). This may change in the future.
