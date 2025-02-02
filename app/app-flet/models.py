from pydantic import BaseModel, EmailStr

class EmailModel(BaseModel):
    email: EmailStr
