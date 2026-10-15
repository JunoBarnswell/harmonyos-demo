import { InfoCard } from '../components/InfoCard';

@Component
export struct GuidePage {
  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 16 }) {
          InfoCard({ heading: '01 · 页面', description: 'Index.ets 管理首页和待办页。使用 @State 驱动界面更新。' })
          InfoCard({ heading: '02 · 组件', description: 'InfoCard 是可复用组件，通过 @Prop 接收只读展示数据。' })
          InfoCard({ heading: '03 · 导航', description: 'Navigation + NavPathStack 管理页面栈，点击系统返回按钮回到首页。' })
          InfoCard({ heading: '04 · 下一步', description: '可继续接入本地存储、HTTP 服务、登录与业务模块。' })
        }
        .width('100%')
        .padding(20)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F7FB')
    }
    .title('开发指南')
  }
}
