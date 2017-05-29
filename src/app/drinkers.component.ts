import { Component } from '@angular/core';
import { OnInit } from '@angular/core';

import { Drinker } from './drinker';
import { DrinkerService } from './drinker.service';

@Component({
  selector: 'drinkers',
  templateUrl: './drinkers.component.html',
  styleUrls: ['./drinkers.component.css']
})
export class DrinkersComponent implements OnInit {
  drinkers: Drinker[];

  constructor(private drinkerService: DrinkerService) { }

  getDrinkers(): void {
    this.drinkerService.getDrinkers().then(drinkers => this.drinkers = drinkers);
  }

  ngOnInit(): void {
    this.getDrinkers();
  }
}
