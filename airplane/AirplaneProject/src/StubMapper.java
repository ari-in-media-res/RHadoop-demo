import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class StubMapper extends Mapper<LongWritable, Text, Text, IntWritable> {

  @Override
  public void map(LongWritable key, Text value, Context context)
      throws IOException, InterruptedException {

    Text lines = value;
    List<String> tokenList = Arrays.asList(lines.toString().split(","));
    
    String firstfield = tokenList.get(0);
    String deptdelay; 
    String carrier = "";
    String month = "";
    String year = "";
    String carrierID = "";
    int delay = 0;
    
    boolean equalsYear = !firstfield.equals("Year");
    int tokenSize = tokenList.size();
    boolean result = (equalsYear && (tokenSize == 29));
    
    if ( result) {
    	deptdelay = tokenList.get(15);
    	
    	// skip records where departure delay is NA
    	if (!deptdelay.equals("NA")){
    		carrier = tokenList.get(8);
    		year = tokenList.get(0);
    		month = tokenList.get(1);
    		carrierID = carrier + "|" + year + "|" + month;
    		delay = Integer.parseInt(deptdelay);
    		
    		context.write(new Text(carrierID), new IntWritable(delay));
    
    		
    	}
    	
    
    	
    	
    	
    }
    
    
    
  }
}
