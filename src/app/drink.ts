export class Drink {
  $key: string;
  drinkerKey: string;
  amount: number;
  time: string;

  constructor($key: string, drinkerKey: string, amount: number, time: string) {
    this.$key = $key;
    this.drinkerKey = drinkerKey;
    this.amount = amount;
    this.time = time;
  }
}
