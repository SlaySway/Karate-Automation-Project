package utils;

import org.json.JSONException;
import org.skyscreamer.jsonassert.JSONCompare;
import org.skyscreamer.jsonassert.JSONCompareMode;
import org.skyscreamer.jsonassert.JSONCompareResult;

/**
 * @author Ravindra Pallerla
 * 
 */

public class StrictValidation {

	public static JSONCompareResult strictCompare(String BaseResponse, String TargetResponse) {

		JSONCompareResult comparisonResult = null;
		try {

			JSONCompareResult resultComp = JSONCompare.compareJSON(BaseResponse, TargetResponse,
					JSONCompareMode.STRICT);
			if (null != resultComp && !"".equalsIgnoreCase(resultComp.toString())
					&& !"".equalsIgnoreCase(resultComp.toString().trim())) {

				comparisonResult = resultComp;

			} else {

				comparisonResult = null;

			}

		} catch (JSONException e) {
			e.printStackTrace();
		}

		return comparisonResult;

	}

}
