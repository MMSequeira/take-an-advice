package pt.iscte.dsi.taa.policies.designbycontract;

public privileged aspect TestHelper {

	private void Rational.setInvalidState() {
		denominator = 0;
	}
	
	static void setInvalidState(final Rational r) {
		r.setInvalidState();
	}
	
}
