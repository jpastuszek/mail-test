Feature: SMTP with IMAP access
  In order to get e-mail via IMAP it has to be sent to the server via SMTP

  Scenario: Sending e-mail via SMTP and receiving via TLS encrypted IMAP
    Given test e-mail from test@sigquit.net to kazuya@sigquit.net
    When I send it to nina
    Then I should find it in nina IMAP inbox authenticated with LOGIN kazuya:pik2bar9 over TLS connection within 5 seconds
