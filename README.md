#  JankyTable Q&A

**Q:** How many threads are active at the breakpoint?
**A:** 7

**Q:** How many queues?
**A:** 2

**Q:** What is the thread number of the main queue?
**A:** 1

**Q:** What is the last function executed prior to the breakpoint?
**A:** View did load

**Q:** What is the first function executed on the main queue/main thread?
**A:** App Delegate

**Q:** Why do you think it takes so long to present the images to the user?
**A:** Needs to apply the filter to the pictures before displaying the cells on screen.

**Q:** Why is scrolling so slow?
**A:** Need to apply filter to the incoming cells as they come.

**Q:** What could you do to resolve these 2 egregious UI issues?
**A:** Having the filter be applied on a different thread from the one that loads the cells.
