export class Drinker {
  id: number;
  name: string;
  drank: number;

  constructor(id: number, name: string) {
    this.id = id;
    this.name = name;
    this.drank = 0;
  }

  public addDrink(amount: number): void {
    this.drank += amount;
  }
}
