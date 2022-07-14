import {Component} from "@angular/core";

@Component({
  selector: 'app-student',
  //template: '<h1>Day la comnponent cua Student</h1>'
  templateUrl: './student.component.html'
})

export class StudentComponent {
  studentName = 'Truong Van Nam';
  age = 18;
  phoneNumber = '09430503258';

  increaseAge(){
    this.age++;
  }
  decreaseAge(){
    this.age--;
  }
}
