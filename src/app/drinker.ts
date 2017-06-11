export class Drinker {
  $key: string;
  name: string;
  drank: number;

  constructor($key: string, name: string, drank: number) {
    this.$key = $key;
    this.name = name;
    this.drank = drank;
  }

  public addDrink(amount: number): void {
    this.drank += amount;
  }
}
