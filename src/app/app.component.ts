import { Component } from '@angular/core';

import { DrinkerService } from './drinker.service';

@Component({
  selector: 'app-root',
  providers: [DrinkerService],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'Water Wars';
}
