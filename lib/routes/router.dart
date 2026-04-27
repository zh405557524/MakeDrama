part of 'package:make_drama/routes/index.dart';

class CustomRouter {
  const CustomRouter._();

  static final GoRouter config = GoRouter(
    initialLocation: '/',
    observers: [AppRouteObserver()],
    routes: [
      GoRoute(
        name: RouteName.home,
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: RouteName.storyInput,
        path: '/create/story',
        builder: (context, state) => const StoryInputPage(),
      ),
      GoRoute(
        name: RouteName.characterGenerate,
        path: '/create/characters',
        builder: (context, state) => const CharacterGeneratePage(),
      ),
      GoRoute(
        name: RouteName.sceneGenerate,
        path: '/create/scenes',
        builder: (context, state) => const SceneGeneratePage(),
      ),
      GoRoute(
        name: RouteName.storyboardEdit,
        path: '/create/storyboards',
        builder: (context, state) => const StoryboardEditPage(),
      ),
      GoRoute(
        name: RouteName.storyboardCharacterSelect,
        path: '/create/storyboards/characters',
        builder: (context, state) => const StoryboardCharacterSelectPage(),
      ),
      GoRoute(
        name: RouteName.storyboardSceneSelect,
        path: '/create/storyboards/scene',
        builder: (context, state) => const StoryboardSceneSelectPage(),
      ),
      GoRoute(
        name: RouteName.videoPreview,
        path: '/create/preview',
        builder: (context, state) => const VideoPreviewPage(),
      ),
    ],
  );
}
