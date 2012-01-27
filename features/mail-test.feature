Feature: SMTP with IMAP access
  In order to get e-mail via IMAP it has to be sent to the server via SMTP

  @deliver
  Scenario: Send e-mail directly to unauthenticated SMTP and check it over TLS authenticated IMAP
    Given test e-mail from test@sigquit.net to kazuya@test.solsoft.pl
    When I send it to test.solsoft.pl
	Then I should get no SMTP error
    Then I should find it in test.solsoft.pl IMAP inbox authenticated with LOGIN kazuya@test.solsoft.pl:test21ds34 over TLS connection within 10 seconds

  @external
  Scenario: Send e-mail to external TLS authenticated SMTP server and check it has arrived in TLS authenticated IMAP
    Given test e-mail from kazuya@sigquit.net to kazuya@test.solsoft.pl
    When I send it to mail.sigquit.net authenticated with LOGIN mailtest:test21ds35 over TLS connection
	Then I should get no SMTP error
    Then I should find it in test.solsoft.pl IMAP inbox authenticated with LOGIN kazuya@test.solsoft.pl:test21ds34 over TLS connection within 10 seconds

  @send
  Scenario: Send e-mail through TLS authenticated SMTP and check it has arrived in external TLS authenticated IMAP
    Given test e-mail from kazuya@test.solsoft.pl to kazuya@sigquit.net
    When I send it to test.solsoft.pl authenticated with LOGIN kazuya@test.solsoft.pl:test21ds34 over TLS connection
	Then I should get no SMTP error
    Then I should find it in mail.sigquit.net IMAP inbox authenticated with LOGIN mailtest:test21ds35 over TLS connection within 10 seconds

  @relay
  Scenario: Send e-mail through non authenticated SMTP should fail
    Given test e-mail from kazuya@test.solsoft.pl to kazuya@sigquit.net
    When I send it to test.solsoft.pl
	Then I should get SMTP error: Relay access denied

