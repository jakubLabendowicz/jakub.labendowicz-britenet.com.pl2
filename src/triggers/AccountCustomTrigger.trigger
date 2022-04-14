trigger AccountCustomTrigger on Account (before insert, before update) {
    for(Account acc : Trigger.New) {
        if(acc.Industry != null && (acc.Industry == 'Banking' || acc.Industry == 'Healthcare')){
         acc.Rating = 'Hot';
        }
    }
}