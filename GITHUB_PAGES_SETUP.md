# Publish the Flutter app to GitHub Pages

The workflow belongs in `.github/workflows/deploy.yml`. `.git` contains Git's internal history and configuration; a workflow placed there is not uploaded or detected. Git creates `.git` itself when you initialize or clone a repository.

1. Extract this ZIP. Open the `post_reader_favorites` folder.
2. Create a GitHub repository (public if using GitHub Free).
3. Upload/commit the CONTENTS of the project folder to the repository root: `pubspec.yaml`, `lib/`, `assets/`, `test/`, `tool/`, and `.github/` alongside one another. Do not upload just the ZIP. Ensure `.github` is included; some file pickers hide it. Git via VS Code or GitHub Desktop can commit it normally.
4. In GitHub open the repository's Settings > Pages. Under Build and deployment, set Source to GitHub Actions.
5. Push your code to `main` or `master`. If the first run happened before Pages was enabled, open Actions > Deploy Flutter library to GitHub Pages > Run workflow, or rerun the failed workflow.
6. Wait for the build and deploy jobs to pass. The deployment job's link and Settings > Pages show the live address.

The workflow installs Flutter, generates Android/web platform files, downloads packages, runs analysis/tests, builds Flutter web, and publishes `build/web`. It uses GitHub Pages metadata to set the correct base path for project sites or account sites. No deployment password or personal access token is required by this workflow.

If starting with a local folder and an empty remote repo, run in its terminal (replace YOUR-USER/YOUR-REPO):

```bash
git init
git add .
git commit -m "Connect MockAPI and add library web deployment"
git branch -M main
git remote add origin https://github.com/YOUR-USER/YOUR-REPO.git
git push -u origin main
```

If already in a cloned repository, do not repeat init or add origin; commit and push your changes. Keep `.github/workflows/deploy.yml` at the repository root even if you previously uploaded a nested project. This workflow assumes `pubspec.yaml` is also at the root.

GitHub Pages serves the compiled Flutter web app. For local development use `flutter run -d chrome`, not the VS Code Live Server extension on Dart source files. Favorites/notes remain local to each browser and origin. Posts added/deleted in MockAPI are shared across users of this endpoint. No sign-in or per-user delete authorization is implemented in this classroom app.

Verification: the workflow has been prepared and its YAML parsed, but has not run in your GitHub repository. Enable Pages and confirm a successful Actions run before sharing the URL.

Official references:
https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages
https://docs.flutter.dev/deployment/web
https://docs.flutter.dev/ui/navigation/url-strategies
