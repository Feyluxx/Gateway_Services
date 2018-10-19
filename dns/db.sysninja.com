;
; BIND data file for sysninja.
;
$TTL	604800
@	IN	SOA	sysninja. root.sysninja. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	sysninja.
@	IN	A	172.16.144.214
*	IN	A	172.16.144.214
