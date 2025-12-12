This PR add generic response type, when response type is `allOf`, generate with `SomeType<OtherType>`
Example:

```json
{
    "responses": {
        "200": {
            "description": "Success",
            "schema": {
                "allOf": [
                    {
                        "$ref": "#/definitions/model.PaginationRes"
                    },
                    {
                        "type": "object",
                        "properties": {
                            "items": {
                                "type": "array",
                                "items": {
                                    "$ref": "#/definitions/model.AssistanceSimpleListRes"
                                }
                            }
                        }
                    }
                ]
            }
        }
    }
}
``` 

```json
{
	"items": [
        {
			"id": 0,
			"time": "string"
		},
		{
			"id": 1,
			"time": "string"
		}
	],
	"pagination": {
		"current": 0,
		"pages": 0,
		"total": 0
	}
}
```

This PR will generate ModelPaginationRes<ModelAssistanceSimpleListRes>
