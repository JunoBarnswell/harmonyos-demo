@Component
export struct InfoCard {
  @Prop heading: string = '';
  @Prop description: string = '';

  build() {
    Column({ space: 8 }) {
      Text(this.heading)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#172033')
      Text(this.description)
        .fontSize(14)
        .fontColor('#64748B')
        .lineHeight(22)
    }
    .alignItems(HorizontalAlign.Start)
    .padding(20)
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(16)
  }
}
