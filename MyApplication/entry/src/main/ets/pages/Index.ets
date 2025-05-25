import { AmapMcpService, McpWeatherForecast, McpWeatherCast } from '../common/AmapMcpService';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  @State address: string = '';
  @State weatherInfo: McpWeatherForecast | null = null;
  @State isLoading: boolean = false;
  @State errorMessage: string = '';

  build() {
    Column() {
      // 标题
      Text('天气查询')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1f2937')
        .margin({ top: 40, bottom: 30 })

      // 地址输入区域
      Column() {
        Text('请输入地址')
          .fontSize(16)
          .fontColor('#6b7280')
          .alignSelf(ItemAlign.Start)
          .margin({ bottom: 8 })

        TextInput({ placeholder: '例如：北京市朝阳区' })
          .width('100%')
          .height(50)
          .fontSize(16)
          .borderRadius(8)
          .backgroundColor('#f9fafb')
          .border({ width: 1, color: '#e5e7eb' })
          .onChange((value: string) => {
            this.address = value;
            this.errorMessage = '';
          })

        Button('查询天气')
          .width('100%')
          .height(50)
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#3b82f6')
          .borderRadius(8)
          .margin({ top: 16 })
          .enabled(!this.isLoading && this.address.length > 0)
          .onClick(() => {
            this.queryWeather();
          })

        if (this.isLoading) {
          Row() {
            LoadingProgress()
              .width(20)
              .height(20)
              .color('#3b82f6')
            Text('查询中...')
              .fontSize(14)
              .fontColor('#6b7280')
              .margin({ left: 8 })
          }
          .margin({ top: 16 })
        }

        if (this.errorMessage) {
          Text(this.errorMessage)
            .fontSize(14)
            .fontColor('#ef4444')
            .margin({ top: 16 })
        }
      }
      .width('100%')
      .padding(20)
      .backgroundColor(Color.White)
      .borderRadius(12)
      .shadow({ radius: 8, color: '#00000010', offsetX: 0, offsetY: 2 })
      .margin({ bottom: 20 })

      // 天气信息显示区域
      if (this.weatherInfo) {
        this.WeatherInfoCard()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f3f4f6')
    .padding(16)
  }

  @Builder WeatherInfoCard() {
    Column() {
      // 城市信息
      Row() {
        Text(this.weatherInfo?.city || '')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1f2937')
        
        Text(this.weatherInfo?.province || '')
          .fontSize(14)
          .fontColor('#6b7280')
          .margin({ left: 8 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .margin({ bottom: 16 })

      // 更新时间
      Text(`更新时间：${this.weatherInfo?.reporttime || ''}`)
        .fontSize(12)
        .fontColor('#9ca3af')
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 20 })

      // 天气预报列表
      if (this.weatherInfo?.casts && this.weatherInfo.casts.length > 0) {
        Column() {
          ForEach(this.weatherInfo.casts, (cast: McpWeatherCast, index: number) => {
            this.WeatherCastItem(cast, index)
          })
        }
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 8, color: '#00000010', offsetX: 0, offsetY: 2 })
  }

  @Builder WeatherCastItem(cast: McpWeatherCast, index: number) {
    Column() {
      Row() {
        Column() {
          Text(cast.date)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#1f2937')
          Text(cast.week)
            .fontSize(12)
            .fontColor('#6b7280')
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Column() {
          Text('白天')
            .fontSize(12)
            .fontColor('#6b7280')
          Text(cast.dayweather)
            .fontSize(14)
            .fontColor('#1f2937')
            .margin({ top: 2 })
          Text(`${cast.daytemp}°C`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#3b82f6')
            .margin({ top: 4 })
          Text(`${cast.daywind} ${cast.daypower}`)
            .fontSize(12)
            .fontColor('#6b7280')
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)

        Column() {
          Text('夜晚')
            .fontSize(12)
            .fontColor('#6b7280')
          Text(cast.nightweather)
            .fontSize(14)
            .fontColor('#1f2937')
            .margin({ top: 2 })
          Text(`${cast.nighttemp}°C`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#6366f1')
            .margin({ top: 4 })
          Text(`${cast.nightwind} ${cast.nightpower}`)
            .fontSize(12)
            .fontColor('#6b7280')
            .margin({ top: 2 })
        }
        .alignItems(HorizontalAlign.Center)
        .layoutWeight(1)
      }
      .width('100%')
      .padding(16)

      if (index < (this.weatherInfo?.casts?.length || 0) - 1) {
        Divider()
          .color('#e5e7eb')
          .strokeWidth(1)
      }
    }
  }

  private async queryWeather() {
    if (!this.address.trim()) {
      this.errorMessage = '请输入地址';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';
    this.weatherInfo = null;

    try {
      hilog.info(0x0000, 'Index', 'Querying weather for address: %{public}s', this.address);
      const result = await AmapMcpService.getWeatherByAddress(this.address.trim());
      
      if (result) {
        this.weatherInfo = result;
        hilog.info(0x0000, 'Index', 'Weather query successful');
      } else {
        this.errorMessage = '未找到该地址的天气信息，请检查地址是否正确';
        hilog.error(0x0000, 'Index', 'Weather query returned null result');
      }
    } catch (error) {
      this.errorMessage = '查询失败，请检查网络连接';
      hilog.error(0x0000, 'Index', 'Weather query failed: %{public}s', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }
} 