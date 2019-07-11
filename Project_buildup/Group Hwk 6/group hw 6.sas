proc ttest data=hyp3 cochran ci=equal umpu;
      class d_pin;
      var ret30;
run;