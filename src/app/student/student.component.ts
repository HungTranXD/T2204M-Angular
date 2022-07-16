import {Component, Input} from "@angular/core";
import {IStudent} from "../interfaces/student.interface";

@Component({
  selector: 'app-student',
  //template: '<h1>Day la comnponent cua Student</h1>'
  templateUrl: './student.component.html'
})

export class StudentComponent {
  // @Input()
  // studentName !: string;

  @Input("studentName") studentName !: string;
  @Input("studentAge") studentAge !: number;

  // age = 18;
  phoneNumber = '09430503258';

  increaseAge(){
    this.studentAge++;
  }
  decreaseAge(){
    this.studentAge--;
  }

  //Thay vi tao tung bien rieng le thi tao 1 object lon
  @Input()
  data !: IStudent;
}
