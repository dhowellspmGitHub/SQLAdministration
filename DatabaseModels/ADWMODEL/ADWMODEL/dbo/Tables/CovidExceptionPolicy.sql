CREATE TABLE [dbo].[CovidExceptionPolicy] (
    [PolicyNbr]      VARCHAR (16)  NOT NULL,
    [ProcessDt]      DATETIME2 (7) NULL,
    [UserUpdatedId]  CHAR (8)      NOT NULL,
    [PaymentDueDate] DATETIME      NULL,
    [UserCreatedId]  CHAR (8)      NOT NULL,
    [InsertedTmstmp] DATETIME2 (7) NOT NULL,
    [UpdatedTmstmp]  DATETIME2 (7) NOT NULL,
    [LastActionCd]   CHAR (1)      NOT NULL
);

