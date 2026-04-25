enum WorkStep { draft, characters, scenes, storyboards, preview, completed }

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
