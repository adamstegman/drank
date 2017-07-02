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
  startDrinksAtTimestampCallback: any;
  endDrinksAtTimestampCallback: any;
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

    this.updateStartDrinksAtTimestamp();
    this.updateEndDrinksAtTimestamp();
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

  setDrinkTimestamps(startAt: string, endAt: string): void {
    clearTimeout(this.startDrinksAtTimestampCallback);
    clearTimeout(this.endDrinksAtTimestampCallback);
    if (startAt && endAt) {
      this.startDrinksAtTimestamp.next(startAt);
      this.endDrinksAtTimestamp.next(endAt);
    } else if (startAt) {
      this.startDrinksAtTimestamp.next(startAt);
      this.updateEndDrinksAtTimestamp();
    } else {
      this.updateStartDrinksAtTimestamp();
      this.updateEndDrinksAtTimestamp();
    }
  }

  updateStartDrinksAtTimestamp(): void {
    const beginningOfDay = moment().startOf('day');
    this.startDrinksAtTimestamp.next(beginningOfDay.clone().utc().toJSON());

    const msUntilTomorrow = beginningOfDay.clone().add(1, 'day').diff(moment.now());
    this.startDrinksAtTimestampCallback = setTimeout(this.updateStartDrinksAtTimestamp.bind(this), msUntilTomorrow);
  };

  updateEndDrinksAtTimestamp(): void {
    const endOfDay = moment().endOf('day');
    this.endDrinksAtTimestamp.next(endOfDay.clone().utc().toJSON());

    const msUntilTomorrow = endOfDay.clone().startOf('day').add(1, 'day').diff(moment.now());
    this.endDrinksAtTimestampCallback = setTimeout(this.updateEndDrinksAtTimestamp.bind(this), msUntilTomorrow);
  };
}
