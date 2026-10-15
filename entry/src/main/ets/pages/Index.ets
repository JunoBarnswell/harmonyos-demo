import { InfoCard } from '../components/InfoCard';
import { TodoItem } from '../model/TodoItem';
import { GuidePage } from './GuidePage';

@Entry
@Component
struct Index {
  private pathStack: NavPathStack = new NavPathStack();
  private nextTodoId: number = 3;
  @State count: number = 0;
  @State draft: string = '';
  @State feedback: string = '';
  @State todos: TodoItem[] = [
    new TodoItem(1, '运行第一个鸿蒙应用', true),
    new TodoItem(2, '试试添加一条待办')
  ];

  private addTodo(): void {
    const title: string = this.draft.trim();
    if (title.length === 0) {
      this.feedback = '请输入待办内容';
      return;
    }
    if (this.todos.length >= 100) {
      this.feedback = 'Demo 最多保留 100 条待办，请先删除部分内容';
      return;
    }
    this.todos = this.todos.concat([new TodoItem(this.nextTodoId++, title)]);
    this.draft = '';
    this.feedback = '已添加';
  }

  private toggleTodo(id: number): void {
    // Replace the array and items to ensure @State observes each update.
    this.todos = this.todos.map((item: TodoItem) =>
      new TodoItem(item.id, item.title, item.id === id ? !item.completed : item.completed));
    this.feedback = '';
  }

  private deleteTodo(id: number): void {
    this.todos = this.todos.filter((item: TodoItem) => item.id !== id);
    this.feedback = '已删除';
  }

  @Builder
  destination(name: string) {
    if (name === 'Guide') {
      GuidePage()
    }
  }

  @Builder
  home() {
    Scroll() {
      Column({ space: 16 }) {
        Column({ space: 12 }) {
          Text('你好，HarmonyOS')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text('从一个小应用，开始原生鸿蒙开发。')
            .fontSize(14)
            .fontColor('#DBEAFE')
        }
        .alignItems(HorizontalAlign.Start)
        .padding(24)
        .width('100%')
        .backgroundColor('#2563EB')
        .borderRadius(20)

        InfoCard({ heading: 'ArkTS + ArkUI', description: 'Stage 模型 · 声明式界面 · 组件化开发' })

        Column({ space: 16 }) {
          Text('状态交互示例').fontSize(18).fontWeight(FontWeight.Medium)
          Text(this.count.toString()).fontSize(48).fontColor('#2563EB')
          Row({ space: 12 }) {
            Button('重置').onClick(() => { this.count = 0; })
              .backgroundColor('#E2E8F0').fontColor('#172033').layoutWeight(1)
            Button('点击 +1').onClick(() => { this.count += 1; })
              .backgroundColor('#2563EB').layoutWeight(1)
          }.width('100%')
        }
        .width('100%')
        .padding(20)
        .backgroundColor(Color.White)
        .borderRadius(16)

        Button('查看开发指南')
          .width('100%')
          .height(48)
          .backgroundColor('#172033')
          .onClick(() => { this.pathStack.pushPath({ name: 'Guide' }); })
      }
      .width('100%')
      .padding(20)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  todoList() {
    Column({ space: 12 }) {
      Text('我的待办').fontSize(24).fontWeight(FontWeight.Bold).fontColor('#172033')
      Text('当前 ' + this.todos.length.toString() + ' 条，已完成 ' +
        this.todos.filter((item: TodoItem) => item.completed).length.toString() + ' 条')
        .fontSize(14).fontColor('#64748B')
      Row({ space: 8 }) {
        TextInput({ placeholder: '输入待办（最多 60 字）', text: this.draft })
          .maxLength(60)
          .layoutWeight(1)
          .onChange((value: string) => { this.draft = value; this.feedback = ''; })
          .onSubmit(() => { this.addTodo(); })
        Button('添加').backgroundColor('#2563EB').onClick(() => { this.addTodo(); })
      }.width('100%')
      Text('数据仅保留在本次运行中，重启应用后恢复初始示例。')
        .fontSize(12).fontColor('#64748B')
      Text(this.feedback).fontSize(13).fontColor('#2563EB')

      if (this.todos.length === 0) {
        InfoCard({ heading: '暂无待办', description: '在上方输入内容，添加第一条待办。' })
      }

      List({ space: 10 }) {
        ForEach(this.todos, (item: TodoItem) => {
          ListItem() {
            Row({ space: 8 }) {
              Checkbox({ name: item.id.toString() })
                .select(item.completed)
                .accessibilityText('完成待办：' + item.title)
                .onChange((selected: boolean) => {
                  if (selected !== item.completed) {
                    this.toggleTodo(item.id);
                  }
                })
              Text(item.title)
                .layoutWeight(1)
                .fontSize(16)
                .fontColor(item.completed ? '#64748B' : '#172033')
                .decoration({ type: item.completed ? TextDecorationType.LineThrough : TextDecorationType.None })
              Button('删除')
                .fontSize(12)
                .backgroundColor('#FEF2F2')
                .fontColor('#DC2626')
                .accessibilityText('删除待办：' + item.title)
                .onClick(() => { this.deleteTodo(item.id); })
            }
            .width('100%')
            .padding(12)
            .backgroundColor(Color.White)
            .borderRadius(12)
          }
        }, (item: TodoItem) => item.id.toString())
      }
      .width('100%')
      .layoutWeight(1)
    }
    .padding(20)
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }

  build() {
    Navigation(this.pathStack) {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() { this.home() }.tabBar('首页')
        TabContent() { this.todoList() }.tabBar('待办')
      }
      .width('100%')
      .height('100%')
      .barHeight(56)
      .backgroundColor('#F5F7FB')
    }
    .title('Harmony Demo')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .navDestination(this.destination)
    .width('100%')
    .height('100%')
  }
}
