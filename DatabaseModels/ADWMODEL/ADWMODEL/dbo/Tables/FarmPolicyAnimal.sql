CREATE TABLE [dbo].[FarmPolicyAnimal] (
    [PolicyId]            INT           NOT NULL,
    [AnimalNbr]           INT           NOT NULL,
    [PolicyNbr]           VARCHAR (16)  NOT NULL,
    [AnimalTypeDesc]      VARCHAR (50)  NULL,
    [AnimalBreedDesc]     VARCHAR (50)  NULL,
    [OtherAnimalTypeDesc] VARCHAR (250) NULL,
    [OtherBreedDesc]      VARCHAR (250) NULL,
    [BiteHistoryInd]      CHAR (1)      NULL,
    [CreatedTmstmp]       DATETIME      NOT NULL,
    [UserCreatedId]       CHAR (8)      NOT NULL,
    [UpdatedTmstmp]       DATETIME2 (7) NOT NULL,
    [UserUpdatedId]       CHAR (8)      NOT NULL,
    [LastActionCd]        CHAR (1)      NOT NULL,
    [SourceSystemCd]      CHAR (2)      NOT NULL,
    CONSTRAINT [PK_FarmPolicyAnimal] PRIMARY KEY CLUSTERED ([PolicyId] ASC, [AnimalNbr] ASC) ON [POLICYCD],
    CONSTRAINT [FK_FarmPolicyAnimal_FarmPolicy_01] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[FarmPolicy] ([PolicyId])
) ON [POLICYCD];


GO
CREATE NONCLUSTERED INDEX [IX_FarmPolicyAnimal_01]
    ON [dbo].[FarmPolicyAnimal]([PolicyId] ASC)
    ON [POLICYCI];

