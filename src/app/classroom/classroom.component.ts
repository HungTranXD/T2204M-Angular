import {Component} from "@angular/core";

@Component({
  selector: 'app-classroom',
  templateUrl: './classroom.component.html'
})

export class ClassroomComponent {
  className = 'T2204M';

  changeName(){
    this.className = 'T2203E';
  }
}
