/**
 * 
 * @author Omar
 * Test project for metrics; 47 Lines of Code
 */
public class Main
{
	/**
	 * My main constructor
	 */
	public Main()
	{
		/* Construction stuff
		 	Goes here */
	}
	
    //
    public Main(int i) {
    	System.out.println();
    }
    
    /**
 */
    public Main(boolean b) {
    	System.out.println();
    }
	
	public void myTestMethod0()
	{
		/* Comment1 */ /* Comment2 */
		if(this.equals(null))
		{
			System.out.println("wtf is going on?!?"); //This can't happen
		}
		else
		{
			System.out.println("Yay Main constructed!"); /* This always happens */
		}
		
		/*
		 // Commentception!
		 */
	}
	
	public void myTestMethod1()
	{
		System.out.println("Comment in \\String");
		System.out.println("Multiline comment in String:" +
				"\\MyComment"
				+ "\n");
		System.out.println("Multiline comment in String:" +
				"/* MyComment" +
				"over multiple" +
				"lines */"
				+ "\n");
	}
	/*Comment after closing bracket
	 * 
	 */
	
	public void myTestMethod2()
	{
		System.out.println
			("Multiline Statement");
		/* Comment with
		
		 * Whiteline
		 */
	}
	
	public static void main(String[] args)
	{
		// TODO Auto-generated method stub
		System.out.println("Test 1");
		
		System.out.println("Test 2");
		
		Main m = new Main();
		m.myTestMethod1();
		//End comment
	}
}