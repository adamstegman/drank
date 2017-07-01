import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import 'rxjs/add/operator/map';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';

import { AngularFireDatabase, FirebaseListObservable } from 'angularfire2/database';
import * as moment from 'moment';

import { Drinker } from './drinker';
import { Drink } from './drink';

@Injectable()
export class DrinksService {
  startDrinksAtTimestamp: BehaviorSubject<string>;
  endDrinksAtTimestamp: BehaviorSubject<string>;
  drinks: FirebaseListObservable<Drink[]>;

  constructor(private db: AngularFireDatabase) {
    this.startDrinksAtTimestamp = new BehaviorSubject(moment().startOf('day').utc().toJSON());
    this.endDrinksAtTimestamp = new BehaviorSubject(moment().endOf('day').utc().toJSON());
    this.drinks = db.list('/drinks', {
      query: {
        orderByChild: 'time',
        startAt: this.startDrinksAtTimestamp,
        endAt: this.endDrinksAtTimestamp
      }
    });

    this.updateDrinkTimestamps();
  }

  addDrink(drinker: Drinker, drank: number): void {
    this.drinks.push({drinkerKey: drinker.$key, amount: drank, time: moment.utc().toJSON()});
  }

  getDrinks(drinker: Drinker): Observable<Drink[]> {
    return this.drinks.
      map(drinks => drinks.filter(drink => drink.drinkerKey == drinker.$key));
  }

  getDrank(drinker: Drinker): Observable<number> {
    return this.getDrinks(drinker).
      map(drinks => drinks.reduce((acc, drink) => acc + drink.amount, 0));
  }

  updateDrinkTimestamps(): void {
    const beginningOfDay = moment().startOf('day');
    this.startDrinksAtTimestamp.next(beginningOfDay.clone().utc().toJSON());
    const endOfDay = beginningOfDay.clone().endOf('day');
    this.endDrinksAtTimestamp.next(endOfDay.clone().utc().toJSON());

    const msUntilTomorrow = beginningOfDay.clone().add(1, 'day').diff(moment.now());
    setTimeout(this.updateDrinkTimestamps.bind(this), msUntilTomorrow);
  };
}
