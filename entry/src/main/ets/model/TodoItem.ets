// Keep the model free of UI dependencies so a repository can be added later.
export class TodoItem {
  id: number;
  title: string;
  completed: boolean;

  constructor(id: number, title: string, completed: boolean = false) {
    this.id = id;
    this.title = title;
    this.completed = completed;
  }
}
