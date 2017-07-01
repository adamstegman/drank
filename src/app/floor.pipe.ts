import { Pipe, PipeTransform } from '@angular/core';

@Pipe({name: 'floor'})
export class FloorPipe implements PipeTransform {
  transform(input: number) {
    if (input) {
      return Math.floor(input);
    } else {
      return 0;
    }
  }
}
