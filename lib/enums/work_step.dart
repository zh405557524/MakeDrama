enum WorkStep { draft, characters, scenes, storyboards, preview, completed }

WorkStep workStepFromJson(dynamic value) {
  final normalized = value?.toString().toLowerCase();
  switch (normalized) {
    case 'characters':
      return WorkStep.characters;
    case 'scenes':
      return WorkStep.scenes;
    case 'storyboards':
      return WorkStep.storyboards;
    case 'preview':
      return WorkStep.preview;
    case 'completed':
      return WorkStep.completed;
    case 'draft':
    default:
      return WorkStep.draft;
  }
}

extension WorkStepWire on WorkStep {
  String get wireName {
    switch (this) {
      case WorkStep.draft:
        return 'draft';
      case WorkStep.characters:
        return 'characters';
      case WorkStep.scenes:
        return 'scenes';
      case WorkStep.storyboards:
        return 'storyboards';
      case WorkStep.preview:
        return 'preview';
      case WorkStep.completed:
        return 'completed';
    }
  }
}

extension WorkStepLabel on WorkStep {
  String get label {
    switch (this) {
      case WorkStep.draft:
        return '草稿';
      case WorkStep.characters:
        return '角色生成';
      case WorkStep.scenes:
        return '场景生成';
      case WorkStep.storyboards:
        return '分镜处理';
      case WorkStep.preview:
        return '视频预览';
      case WorkStep.completed:
        return '已完成';
    }
  }
}
