import burn from 'ic:canisters/burn';

burn.greet(window.prompt("Enter your name:")).then(greeting => {
  window.alert(greeting);
});
