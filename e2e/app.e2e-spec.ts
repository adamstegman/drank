import { DrankPage } from './app.po';

describe('drank App', () => {
  let page: DrankPage;

  beforeEach(() => {
    page = new DrankPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
