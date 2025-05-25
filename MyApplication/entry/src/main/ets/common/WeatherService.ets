import http from '@ohos.net.http';
import hilog from '@ohos.hilog';

// 天气信息接口
export interface WeatherInfo {
  city: string;
  adcode: string;
  province: string;
  reporttime: string;
  casts: WeatherCast[];
}

export interface WeatherCast {
  date: string;
  week: string;
  dayweather: string;
  nightweather: string;
  daytemp: string;
  nighttemp: string;
  daywind: string;
  nightwind: string;
  daypower: string;
  nightpower: string;
}

// 地理编码结果接口
export interface GeoCodeResult {
  formatted_address: string;
  country: string;
  province: string;
  citycode: string;
  city: string;
  district: string;
  township: string;
  neighborhood: object;
  building: object;
  adcode: string;
  street: string;
  number: string;
  location: string;
  level: string;
}

export class WeatherService {
  private static readonly TAG = 'WeatherService';
  private static readonly AMAP_KEY = 'c53a83e2d78a628c652726ba11e88630'; // 请替换为你的高德地图API Key
  private static readonly GEO_URL = 'https://restapi.amap.com/v3/geocode/geo';
  private static readonly WEATHER_URL = 'https://restapi.amap.com/v3/weather/weatherInfo';

  /**
   * 根据地址获取天气信息
   * @param address 地址
   * @returns Promise<WeatherInfo | null>
   */
  static async getWeatherByAddress(address: string): Promise<WeatherInfo | null> {
    try {
      // 第一步：地理编码，获取城市编码
      const geoResult = await this.getGeoCode(address);
      if (!geoResult) {
        hilog.error(0x0000, this.TAG, 'Failed to get geo code for address: %{public}s', address);
        return null;
      }

      // 第二步：根据城市编码获取天气信息
      const weatherInfo = await this.getWeatherByCity(geoResult.city || geoResult.adcode);
      return weatherInfo;
    } catch (error) {
      hilog.error(0x0000, this.TAG, 'Error getting weather: %{public}s', JSON.stringify(error));
      return null;
    }
  }

  /**
   * 地理编码：将地址转换为经纬度和城市信息
   * @param address 地址
   * @returns Promise<GeoCodeResult | null>
   */
  private static async getGeoCode(address: string): Promise<GeoCodeResult | null> {
    return new Promise((resolve, reject) => {
      const httpRequest = http.createHttp();
      const url = `${this.GEO_URL}?key=${this.AMAP_KEY}&address=${encodeURIComponent(address)}`;

      httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      }, (err, data) => {
        if (!err) {
          try {
            const response = JSON.parse(data.result.toString());
            if (response.status === '1' && response.geocodes && response.geocodes.length > 0) {
              resolve(response.geocodes[0]);
            } else {
              hilog.error(0x0000, this.TAG, 'Geo code API error: %{public}s', response.info || 'Unknown error');
              resolve(null);
            }
          } catch (parseError) {
            hilog.error(0x0000, this.TAG, 'Failed to parse geo code response: %{public}s', JSON.stringify(parseError));
            resolve(null);
          }
        } else {
          hilog.error(0x0000, this.TAG, 'Geo code request failed: %{public}s', JSON.stringify(err));
          reject(err);
        }
        httpRequest.destroy();
      });
    });
  }

  /**
   * 根据城市名称或城市编码获取天气信息
   * @param city 城市名称或adcode
   * @returns Promise<WeatherInfo | null>
   */
  private static async getWeatherByCity(city: string): Promise<WeatherInfo | null> {
    return new Promise((resolve, reject) => {
      const httpRequest = http.createHttp();
      const url = `${this.WEATHER_URL}?key=${this.AMAP_KEY}&city=${encodeURIComponent(city)}&extensions=all`;

      httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      }, (err, data) => {
        if (!err) {
          try {
            const response = JSON.parse(data.result.toString());
            if (response.status === '1' && response.forecasts && response.forecasts.length > 0) {
              resolve(response.forecasts[0]);
            } else {
              hilog.error(0x0000, this.TAG, 'Weather API error: %{public}s', response.info || 'Unknown error');
              resolve(null);
            }
          } catch (parseError) {
            hilog.error(0x0000, this.TAG, 'Failed to parse weather response: %{public}s', JSON.stringify(parseError));
            resolve(null);
          }
        } else {
          hilog.error(0x0000, this.TAG, 'Weather request failed: %{public}s', JSON.stringify(err));
          reject(err);
        }
        httpRequest.destroy();
      });
    });
  }
}