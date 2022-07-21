import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppComponent } from './app.component';
import {StudentComponent} from "./student/student.component";
import {ClassroomComponent} from "./classroom/classroom.component";
import {FormsModule} from "@angular/forms";
import {CurrentWeatherComponent} from "./current-weather/current-weather.component";
import {HttpClientModule} from "@angular/common/http";
import {ForecastComponent} from "./forecast/forecast.component";
import {RouterModule, Routes} from "@angular/router";
import {AboutusComponent} from "./aboutus/aboutus.component";
import {LoginComponent} from "./login/login.component";
import {RegisterComponent} from "./register/register.component";

const appRoutes: Routes = [
  {path: '',component: CurrentWeatherComponent},
  {path: 'about-us',component: AboutusComponent},
  {path: 'login',component: LoginComponent},
  {path: 'register',component: RegisterComponent},
];

@NgModule({
  declarations: [
    AppComponent,
    StudentComponent,
    ClassroomComponent,
    CurrentWeatherComponent,
    ForecastComponent,
    AboutusComponent,
    LoginComponent,
    RegisterComponent
  ],
  imports: [
    BrowserModule, FormsModule,
    HttpClientModule,
    RouterModule.forRoot(appRoutes)
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
