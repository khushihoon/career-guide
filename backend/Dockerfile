# Free-hosting friendly image for backend/course_generator_api.dart
# Build context = repo root.  (Render: Environment=Docker, Dockerfile Path=Dockerfile.backend)
FROM dart:stable AS build
WORKDIR /app

# The backend is pure Dart. The app's pubspec depends on the Flutter SDK, so
# the image uses a tiny pubspec with the SAME package name (keeps any
# package:ai_career_app/... imports resolvable) and only the http dependency.
RUN printf 'name: ai_career_app\nenvironment:\n  sdk: ">=3.0.0 <4.0.0"\ndependencies:\n  http: ^1.2.0\n' > pubspec.yaml
RUN dart pub get
COPY lib ./lib
COPY backend ./backend
RUN dart compile exe backend/course_generator_api.dart -o /app/server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/server /app/server
ENV CAREER_GUIDE_ENV=production
ENV TRUST_PROXY=true
EXPOSE 8080
CMD ["/app/server"]