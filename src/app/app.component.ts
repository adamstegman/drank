import { Component } from '@angular/core';
import { OnInit } from '@angular/core';

import { Drinker } from './drinker';
import { DrinkerService } from './drinker.service';

@Component({
  selector: 'app-root',
  providers: [DrinkerService],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'Water Wars';
  drinkers: Drinker[];

  constructor(private drinkerService: DrinkerService) { }

  getDrinkers(): void {
    this.drinkerService.getDrinkers().then(drinkers => this.drinkers = drinkers);
  }

  ngOnInit(): void {
    this.getDrinkers();
  }
}
