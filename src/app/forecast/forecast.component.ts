import {Component} from "@angular/core";
import {HttpClient, HttpParams} from "@angular/common/http";
import {IForecast} from "../interfaces/forecast.interface";

@Component({
  selector: 'app-forecast',
  templateUrl: './forecast.component.html',
  styleUrls: ['./forecast.component.css']
})

export class ForecastComponent {
  data : IForecast | undefined;
  cityCode = 'Hanoi';
  //Lay du lieu tu API cho vao bien data
  constructor(private http: HttpClient) {
  }

  ngOnInit() {
    this.changeCity();
  }

  changeCity() {
    const url = 'http://api.openweathermap.org/data/2.5/forecast';
    let params = new HttpParams();
    params = params.append('q',this.cityCode);
    params = params.append('appid','09a71427c59d38d6a34f89b47d75975c');
    params = params.append('units','metric');
    this.http.get<IForecast>(url,{params: params})
      .subscribe(value => {
        this.data = value;
      })
  }
}
