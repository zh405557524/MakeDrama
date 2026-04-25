import 'package:go_router/go_router.dart';

import '../pages/character_generate/index.dart';
import '../pages/home/index.dart';
import '../pages/scene_generate/index.dart';
import '../pages/story_input/index.dart';
import '../pages/storyboard_character_select/index.dart';
import '../pages/storyboard_edit/index.dart';
import '../pages/storyboard_scene_select/index.dart';
import '../pages/video_preview/index.dart';
import '../store/index.dart';
import 'name.dart';
import 'observers.dart';

class CustomRouter {
  const CustomRouter._();

  static final GoRouter config = GoRouter(
    initialLocation: '/',
    observers: [AppRouteObserver()],
    routes: [
      GoRoute(
        name: RouteName.home,
        path: '/',
        builder: (context, state) => HomePage(controller: WorkStore.to),
      ),
      GoRoute(
        name: RouteName.storyInput,
        path: '/create/story',
        builder: (context, state) => StoryInputPage(controller: WorkStore.to),
      ),
      GoRoute(
        name: RouteName.characterGenerate,
        path: '/create/characters',
        builder: (context, state) =>
            CharacterGeneratePage(controller: WorkStore.to),
      ),
      GoRoute(
        name: RouteName.sceneGenerate,
        path: '/create/scenes',
        builder: (context, state) =>
            SceneGeneratePage(controller: WorkStore.to),
      ),
      GoRoute(
        name: RouteName.storyboardEdit,
        path: '/create/storyboards',
        builder: (context, state) =>
            StoryboardEditPage(controller: WorkStore.to),
      ),
      GoRoute(
        name: RouteName.storyboardCharacterSelect,
        path: '/create/storyboards/characters',
        builder: (context, state) =>
            StoryboardCharacterSelectPage(controller: WorkStore.to),
      ),
      GoRoute(
        name: RouteName.storyboardSceneSelect,
        path: '/create/storyboards/scene',
        builder: (context, state) =>
            StoryboardSceneSelectPage(controller: WorkStore.to),
      ),
      GoRoute(
        name: RouteName.videoPreview,
        path: '/create/preview',
        builder: (context, state) => VideoPreviewPage(controller: WorkStore.to),
      ),
    ],
  );
}
