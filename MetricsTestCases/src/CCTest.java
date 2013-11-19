import java.io.IOException;

@SuppressWarnings("unused")
public class CCTest
{
	public boolean globalBool = true || false && true;
	
	public CCTest()
	{
		String test = "a";
		switch(test)
		{
			case "a":
				break;
			case "b":
				break;
			default:
				break;
		}
		
		boolean bTest = true ? false : true;
	}
	
	public void Method0()
	{
		try
		{
			System.out.println("");
			System.in.available();
		}
		catch(IOException | NullPointerException e)
		{
			
		}
	}
	
	public void Method1()
	{
		if ('a' == 'b' && 'a' == 'c')
		{
			
		}
		if ('a' == 'b' || 'a' == 'c')
		{
			
		}
	}
	
	public void Method2()
	{
		if ('a' == 'b')
		{
			if ('a' == 'b')
			{
				if ('a' == 'b')
				{
					
				}
			}
		}
	}
}
