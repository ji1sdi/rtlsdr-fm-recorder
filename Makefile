TIMERINSTALLDIR=$(HOME)/.config/systemd/user
TIMERDIR=./timers

.PHONY: install-timers uninstall-timers

install-timers: 
	cp $(TIMERDIR)/record-*.timer $(TIMERINSTALLDIR)/
	cp $(TIMERDIR)/record-*.service $(TIMERINSTALLDIR)/
	@ls $(TIMERINSTALLDIR) | grep record-*
	systemctl --user daemon-reload

uninstall-timers:
	$(RM) $(TIMERINSTALLDIR)/record-*
